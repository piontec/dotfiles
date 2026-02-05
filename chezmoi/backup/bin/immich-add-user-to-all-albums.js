/* JS script to share all albums in Immich with another user. 
*  This script is intended to be run with Node.js.
*  
*  Usage: node immich-add-user-to-all-albums.js <URL> <API_KEY> <USER_EMAIL> [role]
*/

const args = process.argv.slice(2);

if (args.length < 3) {
    console.log("Usage: node immich-add-user-to-all-albums.js <URL> <API_KEY> <USER_EMAIL> [role]");
    console.log("Example: node immich-add-user-to-all-albums.js https://immich.example.com my-secret-key user@example.com editor");
    process.exit(1);
}

const IMMICH_INSTANCE_URL = args[0];
const IMMICH_API_KEY = args[1];
const login = args[2];
const role = args[3] || "editor"; // Default to editor if not provided

const API_BASE_URL = `${IMMICH_INSTANCE_URL.replace(/\/$/, "")}/api`;

const headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "x-api-key": IMMICH_API_KEY
};

async function run() {
    try {
        const usersResponse = await fetch(`${API_BASE_URL}/users`, { headers });
        if (!usersResponse.ok) throw new Error(`Failed to fetch users: ${usersResponse.statusText}`);
        const users = await usersResponse.json();
        
        const user = users.find(u => u.email === login);

        if (user) {
            const albumsResponse = await fetch(`${API_BASE_URL}/albums`, { headers });
            if (!albumsResponse.ok) throw new Error(`Failed to fetch albums: ${albumsResponse.statusText}`);
            const albums = await albumsResponse.json();

            for (const album of albums) {
                const albumUser = album.albumUsers.find(au => au.user.id === user.id);
                
                if (albumUser === undefined) {
                    console.log(`Adding user ${user.email} to album ${album.albumName} with role ${role}`);
                    const response = await fetch(`${API_BASE_URL}/albums/${album.id}/users`, {
                        headers,
                        body: JSON.stringify({
                            albumUsers: [{
                                role: role,
                                userId: user.id
                            }]
                        }),
                        method: "PUT"
                    });
                    if (!response.ok) console.error(`Failed to add user to album ${album.albumName}: ${response.statusText}`);
                } else if (albumUser.role !== role) {
                    console.log(`Updating album ${album.albumName} user ${user.email} role from ${albumUser.role} to ${role}`);
                    const response = await fetch(`${API_BASE_URL}/albums/${album.id}/user/${user.id}`, {
                        headers,
                        body: JSON.stringify({
                            role: role,
                        }),
                        method: "PUT"
                    });
                    if (!response.ok) console.error(`Failed to update user role in album ${album.albumName}: ${response.statusText}`);
                } else {
                    console.log(`User ${user.email} already in album ${album.albumName} with role ${role}`);
                }
            }
        } else {
            console.log(`User ${login} not found`);
        }
    } catch (error) {
        console.error("An error occurred:", error.message);
    }
}

run();