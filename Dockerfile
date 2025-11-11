# FROM nginx:alpine
# COPY index.html /usr/share/nginx/html/
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"];

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]
