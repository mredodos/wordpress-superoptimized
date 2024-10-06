# WordPress SuperOptimized

Welcome to **WordPress SuperOptimized**, an advanced and highly optimized Docker image for WordPress designed to meet the needs of high-traffic and feature-rich websites. Created by **An Idea For Business**, this solution integrates cutting-edge technologies to provide a stable, scalable, and high-performance WordPress environment.

## Overview

This Docker image includes the latest versions of **Nginx**, **PHP 8.2-FPM**, and **Varnish** to deliver an optimized and production-ready WordPress experience. Enhanced with key PHP extensions such as **phpredis**, **Relay** (a high-performance Redis solution), and **Opcache**, the image is ideal for demanding WordPress installations, including those using WooCommerce and popular page builders like Breakdance, Bricks Builder, and Elementor.

### Key Features

- **Nginx + Varnish**: Fast request handling, load balancing, and caching for optimal website performance.
- **PHP 8.2-FPM**: Includes essential PHP extensions such as GD, Zip, pdo_mysql, Redis, and Relay.
- **Persistent Volumes**: Persistent volumes are configured for WordPress, themes, and plugins to ensure data continuity.
- **Custom Health Checks**: Advanced Varnish configurations to maximize cache efficiency and minimize server load.
- **Optimized PHP Configuration**: Includes a custom `php.ini` for efficient memory usage and better performance.

## Getting Started

To get started, follow the steps below to clone the repository, build the Docker image, and launch the WordPress environment.

### Prerequisites

- **Docker 19.03+**
- **Docker Compose**
- **External Redis Server** for caching (optional but recommended for better performance)

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/anideaforbusiness/wordpress-superoptimized.git
   cd wordpress-superoptimized
   ```

2. **Set Up Environment Variables**
   Create a `.env` file in the root of the project to set environment variables, such as:

   ```
   WORDPRESS_DB_HOST=db:3306
   WORDPRESS_DB_USER=exampleuser
   WORDPRESS_DB_PASSWORD=examplepass
   WORDPRESS_DB_NAME=exampledb
   MYSQL_ROOT_PASSWORD=rootpass
   ```

3. **Build and Start the Services**
   Use Docker Compose to build and start the WordPress and MariaDB containers:
   ```bash
   docker-compose up -d
   ```

## Usage

You can pull the image directly from Docker Hub:

```bash
docker pull anideaforbusiness/wordpress-superoptimized:latest
```

Alternatively, you can modify the Docker Compose configuration to adapt the environment as per your needs.

### Docker Compose Example

Here's an example of how to deploy using Docker Compose:

```yaml
version: "3.8"

services:
  wordpress:
    image: anideaforbusiness/wordpress-superoptimized:latest
    container_name: wordpress-superoptimized
    environment:
      WORDPRESS_DB_HOST: ${WORDPRESS_DB_HOST}
      WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
      WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
      WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}
    volumes:
      - wordpress_data:/var/www/html
      - plugins_data:/var/www/html/wp-content/plugins
      - themes_data:/var/www/html/wp-content/themes
    depends_on:
      - db
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wordpress.rule=Host(`${WORDPRESS_DOMAIN}`)"
      - "traefik.http.services.wordpress.loadbalancer.server.port=80"

  db:
    image: mariadb:latest
    container_name: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql

volumes:
  wordpress_data:
  plugins_data:
  themes_data:
  db_data:
```

## Why Use WordPress SuperOptimized?

- **Performance**: Integrates Nginx and Varnish for improved speed, ideal for WooCommerce and feature-rich sites.
- **Scalability**: Suitable for both production and development environments, making it versatile for various needs.
- **Easy Deployment**: Ready-to-use Docker setup for quick and straightforward deployment.
- **Customizability**: Fully customizable stack to add or modify plugins, themes, and configurations as required.

## Support

For support or more details, feel free to reach out to us at [An Idea For Business](https://www.aifb.ch).

## Contributing

We welcome contributions to make **WordPress SuperOptimized** even better. Feel free to submit pull requests, suggest features, or report issues.

## License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**. See the [LICENSE](LICENSE) file for more details.
