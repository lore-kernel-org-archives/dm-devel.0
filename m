From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: dm-multipath: del/add map problem
Date: Tue, 21 Feb 2006 16:39:06 -0600
Message-ID: <20060221223906.GC5670@ether.msp.redhat.com>
References: <20060221213805.GA5670@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="p4qYPpj5QlsIQJ0K"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060221213805.GA5670@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 21, 2006 at 03:38:05PM -0600, Benjamin Marzinski wrote:
> When you delete a multipath map, orphaning the path clears out some members
> of the path structure.  Adding that map again doesn't bring them back.
> Specifically, you loose your checker file descriptor.
> 
> The attached patch restores most of the members. It doesn't reset getuid.
> I don't see why that gets cleared in the first place?  Actually, I don't
> see why most of these get cleared, but I didn't look too hard, so I might
> just be missing the reason.
> 
> Note: I cannot get multipathd add the map if it doesn't already exist in
> device mapper, which I assume that I'm supposed to be able to do. To see
> this bug, I need to re-add the map with multipath before re-adding it in
> multipathd. I'll look into that right after I clean up my next patch.
> 
> -Ben

oops. Forgot to attach the patch. Here it is.

--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="adopt.patch"

diff -urpN mp-devel-clean/libmultipath/structs_vec.c mp-devel-patched/libmultipath/structs_vec.c
--- mp-devel-clean/libmultipath/structs_vec.c	2006-02-17 16:07:19.000000000 -0600
+++ mp-devel-patched/libmultipath/structs_vec.c	2006-02-21 16:05:59.000000000 -0600
@@ -67,6 +67,7 @@ adopt_paths (vector pathvec, struct mult
 			if (!find_path_by_dev(mpp->paths, pp->dev) &&
 			    store_path(mpp->paths, pp))
 					return 1;
+			pathinfo(pp, conf->hwtable, DI_PRIO | DI_CHECKER);
 		}
 	}
 	return 0;

--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--p4qYPpj5QlsIQJ0K--
