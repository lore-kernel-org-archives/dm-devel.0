From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: Re: device mapper integrated loops - and one more
	year !
Date: Tue, 21 Nov 2006 23:20:36 +0000
Message-ID: <456389C4.9000902@redhat.com>
References: <1439173022@web.de> <45636B89.7080407@redhat.com>
	<456375CF.10006@rolandpj.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <456375CF.10006@rolandpj.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Roland PJ wrote:
> Hi Bryn
> 
> Just to avoid confusion, this is a different Roland from the original
> query.

Hi Roland,

Noted ;)

> Does this mean that dm-loop does not support sparse loop-back files?

This version doesn't, no. It's not hard to add this though, although it
does have some implications if they are used. We've had some discussions
over whether this is necessary/desirable - is this something you'd like
to see?

> Also, it seems that the approach with dm-loop is that you sniff the
> (current?) file mapping onto its underlying block device. What happens
> if the loopback file is modified, or the file system hosting the
> loopback file does some re-arranging? (I might be way off-tack here -
> this was a first impression of the code).

You'll find this in loop_get_file():

+	/*
+	 * We overload the S_SWAPFILE flag for loop targets because
+	 * it provides the same no-truncate semantics we require, and holding
+	 * onto i_sem is no longer an option.
+	 */
+	mutex_lock(&inode->i_mutex);
+	inode->i_flags |= S_SWAPFILE;
+	mutex_unlock(&inode->i_mutex);

The bmap approach is also used for swapfiles (mm/swapfile.c) - the
S_SWAPFILE inode flag was added in 2.6.16 when the changeover to mutexes
happened.

> I'd be interested in comparing dm-loop to vanilla loop which we
> currently use.
> 

There are patches to dmsetup that allow it to be called as "losetup" or
"dmlosetup", providing the same options as the regular version, so it
should be straightforward to compare.

Regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFY4nE6YSQoMYUY94RAuFyAJ9heEQvTZZ7dEkaIXQ9nxFy7mDx+gCfTozW
FusS8of73r2GfGTchFWRvdc=
=Eisk
-----END PGP SIGNATURE-----
