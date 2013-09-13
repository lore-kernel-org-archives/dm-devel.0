From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/3] dm: allow mempool and bioset reserves
	to be tuned
Date: Fri, 13 Sep 2013 16:30:06 -0400
Message-ID: <20130913203005.GA8635@redhat.com>
References: <1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379098780-15141-1-git-send-email-snitzer@redhat.com>
	<20130913192220.GA8120@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130913192220.GA8120@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

On Fri, Sep 13 2013 at  3:22pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Sep 13 2013 at  2:59pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > You can pull these changes from the 'devel' branch of:
> > git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git
> > 
> > To browse, see:
> > https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel
> > 
> > v2 changes:
> > Simplified the implementation.  Dropped the peak_reserved_rq_based_ios
> > tracking, we'll use the tracepoint patch Jun'ichi Nomura suggested:
> > http://www.redhat.com/archives/dm-devel/2013-September/msg00048.html
> 
> This needs a v3 because the simplified code doesn't handle bounds
> properly (previous version handled remapping 0 to defaults).  But we
> also need a maximum value that we're willing to support.  So if the user
> exceeds that value it is reset to the max supported.

Here is an incremental diff:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a617fe3..033dc26 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -213,6 +213,7 @@ struct dm_md_mempools {
 
 #define RESERVED_BIO_BASED_IOS		16
 #define RESERVED_REQUEST_BASED_IOS	256
+#define RESERVED_MAX_IOS		1024
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_rq_tio_cache;
 
@@ -226,15 +227,36 @@ static unsigned reserved_bio_based_ios = RESERVED_BIO_BASED_IOS;
  */
 static unsigned reserved_rq_based_ios = RESERVED_REQUEST_BASED_IOS;
 
+static unsigned __dm_get_reserved_ios(unsigned *reserved_ios,
+				      unsigned def, unsigned max)
+{
+	unsigned ios = ACCESS_ONCE(*reserved_ios);
+	unsigned modified_ios = 0;
+
+	if (!ios)
+		modified_ios = def;
+	else if (ios > max)
+		modified_ios = max;
+
+	if (modified_ios) {
+		(void)cmpxchg(reserved_ios, ios, modified_ios);
+		ios = modified_ios;
+	}
+
+	return ios;
+}
+
 unsigned dm_get_reserved_bio_based_ios(void)
 {
-	return ACCESS_ONCE(reserved_bio_based_ios);
+	return __dm_get_reserved_ios(&reserved_bio_based_ios,
+				     RESERVED_BIO_BASED_IOS, RESERVED_MAX_IOS);
 }
 EXPORT_SYMBOL_GPL(dm_get_reserved_bio_based_ios);
 
 unsigned dm_get_reserved_rq_based_ios(void)
 {
-	return ACCESS_ONCE(reserved_rq_based_ios);
+	return __dm_get_reserved_ios(&reserved_rq_based_ios,
+				     RESERVED_REQUEST_BASED_IOS, RESERVED_MAX_IOS);
 }
 EXPORT_SYMBOL_GPL(dm_get_reserved_rq_based_ios);
 
