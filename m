From: Luca Berra <bluca@comedia.it>
Subject: Re: Multipath and getuid_callout issues with HPXP1024disk
	array
Date: Thu, 7 Feb 2008 09:39:03 +0100
Message-ID: <20080207083902.GB7665@percy.comedia.it>
References: <20080130185024.GA6165@us.ibm.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F14D@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F14D@exchmail03.ncogroup.com>
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

On Wed, Jan 30, 2008 at 01:56:09PM -0500, Greene, Rick wrote:
>I've been trying to play with using a different command in the
>getuid_callout, but everything I try comes up with "error calling out".
>For example, I wrote my own little shell script that pushes out the same
>scsi_id string, plus some output from a vendor-supplied disk querying
>command, and this is what "multipath -v3" shows for one of the devices
>(they all display similar results):

can you strace the multipath invocation, so maybe we will see if it
really does execute your callout?

I solved a problem similar to yours by using a custom script myself,
about one year ago for a customer using an xp12000, unfortunately i
don't have a copy of the script or of the multipath configuration at
that site.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
