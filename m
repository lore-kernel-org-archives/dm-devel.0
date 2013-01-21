From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: Re: [PATCH V3 13/18] multipath: make reservation_key
 print	out correctly
Date: Mon, 21 Jan 2013 05:50:44 +0000
Message-ID: <F200AD42A082BC4088B232D13A916A8911E1B1E8@SACEXCMBX02-PRD.hq.netapp.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
	<1357970695-3396-13-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-13-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Acked-by: Vijay Chauhan <vijay.chauhan@netapp.com>

Thanks,
Vijay

On January 12, 2013 11:35 AM; Benjamin Marzinski wrote:
>
>This patch fixes the reservation_key print functions, so they print
>it out like it was in the configuration file.  Also, it keeps
>cli_getprstatus() from writing over random memory.
>
>Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>---
> libmultipath/dict.c       | 31 +++++++++++++++++++++++++++++--
> multipathd/cli_handlers.c |  2 +-
> 2 files changed, 30 insertions(+), 3 deletions(-)
>
>diff --git a/libmultipath/dict.c b/libmultipath/dict.c
>index 788ffae..a54dda9 100644
>--- a/libmultipath/dict.c
>+++ b/libmultipath/dict.c
>@@ -2052,8 +2052,22 @@ snprint_mp_prio_args(char * buff, int len, void *
>data)
> static int
> snprint_mp_reservation_key (char * buff, int len, void * data)
> {
>+	int i;
>+	unsigned char *keyp;
>+	uint64_t prkey = 0;
> 	struct mpentry * mpe = (struct mpentry *)data;
>-	return snprintf(buff, len, "%s" , mpe->reservation_key);
>+
>+	if (!mpe->reservation_key)
>+		return 0;
>+	keyp = (unsigned char *)mpe->reservation_key;
>+	for (i = 0; i < 8; i++) {
>+		if (i > 0)
>+			prkey <<= 8;
>+		prkey |= *keyp;
>+		keyp++;
>+	}
>+
>+	return snprintf(buff, len, "0x%" PRIx64, prkey);
> }
>
> 	static int
>@@ -2721,7 +2735,20 @@ snprint_def_wwids_file (char * buff, int len, void *
>data)
> static int
> snprint_def_reservation_key(char * buff, int len, void * data)
> {
>-	return snprintf(buff, len, "%s", conf->reservation_key);
>+	int i;
>+	unsigned char *keyp;
>+	uint64_t prkey = 0;
>+
>+	if (!conf->reservation_key)
>+		return 0;
>+	keyp = (unsigned char *)conf->reservation_key;
>+	for (i = 0; i < 8; i++) {
>+		if (i > 0)
>+			prkey <<= 8;
>+		prkey |= *keyp;
>+		keyp++;
>+	}
>+	return snprintf(buff, len, "0x%" PRIx64, prkey);
> }
>
> static int
>diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
>index 6053b5a..4df37fe 100644
>--- a/multipathd/cli_handlers.c
>+++ b/multipathd/cli_handlers.c
>@@ -947,7 +947,7 @@ cli_getprstatus (void * v, char ** reply, int * len,
>void * data)
>
>
> 	sprintf(*reply,"%d",mpp->prflag);
>-	*reply[1]='\0';
>+	(*reply)[1]='\0';
>
>
> 	condlog(3, "%s: reply = %s", param, *reply);
>--
>1.8.0
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
