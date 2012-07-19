From: Alex Elsayed <eternaleye+usenet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC] dm-thin: Random block placement strategy?
Date: Thu, 19 Jul 2012 14:49:51 -0700
Message-ID: <ju9vdv$vpa$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

This may be insufficiently useful to justify implementing, but I thought it 
was an interesting concept.

One of the current issues with dm-crypt and discard is that enabling it can 
leak information about the filesystem and usage patterns of the disk[1].

If a dm-thin device with a random block placement strategy is layered on top 
of dm-crypt however, this could solve some of the issues involved and 
partially mitigate others.

Such a random block placement strategy would heavily disguise any layout 
patterns that could be used to identify the filesystem, most likely to the 
point of being completely unrecognizable.

Issues arising from discarded blocks being nonzero are avoided by default 
due to dm-thin pre-zeroing allocations (unless skip_block_zeroing is 
enabled).

However, some issues would still be present:

While the *distribution* of unused sectors would be concealed, their 
existence and how many there are would still be detectable.

In addition, the issues with trim and a hidden device are still present.

[1] http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html

_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
