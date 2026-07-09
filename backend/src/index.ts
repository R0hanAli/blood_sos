import app from './app';
import http from 'http';
import { Server } from 'socket.io';
import * as dotenv from 'dotenv';

dotenv.config();

const port = process.env.PORT || 3000;
const server = http.createServer(app);


const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});


io.on('connection', (socket) => {
  console.log(`Socket client connected: ${socket.id}`);

  
  socket.on('join', (userId: string) => {
    socket.join(userId);
    console.log(`User ${userId} joined room channel.`);
  });

  socket.on('disconnect', () => {
    console.log(`Socket client disconnected: ${socket.id}`);
  });
});

server.listen(port, () => {
  console.log(`========================================`);
  console.log(`BloodSOS server running on port: ${port}`);
  console.log(`Socket.io server initialized.`);
  console.log(`========================================`);
});

export { io };
