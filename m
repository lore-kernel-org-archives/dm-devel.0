From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: support using encrypted keys
Date: Tue, 21 Apr 2020 14:27:54 -0400
Message-ID: <20200421182754.GA49104@lobo>
References: <20200420134659.1640089-1-dbaryshkov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200420134659.1640089-1-dbaryshkov@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 20 2020 at  9:46P -0400,
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> From: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>
> 
> Allow one to use encrypted in addition to user and login key types for
> device encryption.
> 
> Signed-off-by: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>

I fixed up some issues, please see the following incremental patch,
I'll get this folded in and staged for 5.8.

Mike

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7056ab54d7dd..a0d9218d411b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2272,10 +2272,10 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 	if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {
 		type = &key_type_logon;
-		set_key = &set_key_user;
+		set_key = set_key_user;
 	} else if (!strncmp(key_string, "user:", key_desc - key_string + 1)) {
 		type = &key_type_user;
-		set_key = &set_key_user;
+		set_key = set_key_user;
 	} else if (!strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
 		type = &key_type_encrypted;
 		set_key = set_key_encrypted;
@@ -2287,8 +2287,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	if (!new_key_string)
 		return -ENOMEM;
 
-	key = request_key(type,
-			  key_desc + 1, NULL);
+	key = request_key(type, key_desc + 1, NULL);
 	if (IS_ERR(key)) {
 		kzfree(new_key_string);
 		return PTR_ERR(key);
