-- source: https://www.ecenica.com/support/answer/change-image-urls-wordpress/
UPDATE wp_posts SET post_content = replace( post_content, 'http://dev.site.com', 'http://prod.site.net' ) ;
UPDATE wp_posts SET guid = replace( guid, 'http://dev.site.com', 'http://prod.site.net' ) ;
