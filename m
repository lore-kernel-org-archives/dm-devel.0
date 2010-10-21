From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: /usr/src/linux/drivers/md/bitmap.c: strange rounding
 lines 855-875
Date: Thu, 21 Oct 2010 16:18:59 +0200
Message-ID: <4CC067F4020000A1000108AB@gwsmtp1.uni-regensburg.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I just found this strange rounding code in /usr/src/linux/drivers/md/bitmap.c:

-----snip-------
        /* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned
long) */
        bitmap->filemap_attr = kzalloc(
                (((num_pages*4/8)+sizeof(unsigned long))
                 /sizeof(unsigned long))
                *sizeof(unsigned long),
                GFP_KERNEL);
---------snip-----

IMHO, this is not rounding, it's just adding one extra "sizeof(unsigned long)":

Instead of using the pattern "((a + b) / b) * b" ==  (a/b + 1) * b == a + b the pattern "((a + b - 1) / b) * b" should be used. Even preferrable: define one macro that does it right, then use it. Example:
#define   ROUND_UP(n, g)  ((((n) + (g) - 1) / (g)) * (g))
#define   ROUND_DWN(n, g) (((n) / (g)) * (g))

Regards,
Ulrich
