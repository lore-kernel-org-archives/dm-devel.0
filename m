From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: How To Get The Latest Code
Date: Wed, 21 Mar 2012 18:28:27 +0000
Message-ID: <4F6A1DCB.7050502@redhat.com>
References: <F2EEB2C045C93A4889A2C09F59EDB208108B17A4@mail2.cs.stonybrook.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F2EEB2C045C93A4889A2C09F59EDB208108B17A4@mail2.cs.stonybrook.edu>
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
Cc: Ming Chen <mchen@cs.stonybrook.edu>
List-Id: dm-devel.ids

On 03/21/2012 06:14 PM, Ming Chen wrote:
> I am new to device-mapper. Can anyone kindly tell me how to checkout
> the latest code of device mapper? It seems there is only link to the
> old code on http://sources.redhat.com/dm/. I googled but I cannot
> find an answer.

Kernel stuff is either in the upstream trees at kernel.org or posted to
this list while it's in development. The userspace library was merged
into the LVM2 source tree a couple of releases back:

http://sourceware.org/git/?p=lvm2.git;a=summary

The libdevmapper sources are in the libdm subdirectory but you should
grab the whole tree as you'll want all the configure scripts and Makefiles.

Regards,
Bryn.
