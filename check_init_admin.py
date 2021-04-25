from seaserv import ccnet_api
import os
if __name__ == "__main__":
    if len(ccnet_api.get_emailusers('DB', 0, 1)) != 0:
        exit(0)
    exit(ccnet_api.add_emailuser(os.getenv("ADMIN_EMAIL"), os.getenv("ADMIN_PASSWORD"), 1, 1))
