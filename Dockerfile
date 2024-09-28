# Sử dụng image node chính thức
FROM node:14 as build

# Đặt thư mục làm việc là /app
WORKDIR /app

# Sao chép file package.json và cài đặt dependencies
COPY package.json ./
RUN npm install

# Sao chép toàn bộ mã nguồn và build dự án
COPY . ./
RUN npm run build

# Sử dụng image NGINX để chạy ứng dụng ReactJS
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 để truy cập vào ứng dụng
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
