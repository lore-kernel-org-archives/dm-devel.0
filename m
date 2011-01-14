From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/3] differentiate between I/O errors
Date: Thu, 13 Jan 2011 20:15:39 -0500
Message-ID: <20110114011538.GB21818__19042.8260168575$1294967828$gmane$org@redhat.com>
References: <20101130225956.GA8882@redhat.com>
	<1291763802-8251-1-git-send-email-snitzer@redhat.com>
	<20101210234036.GA4841@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101210234036.GA4841@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu, sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@sus
List-Id: dm-devel.ids

On Fri, Dec 10 2010 at  6:40pm -0500,
Malahal Naineni <malahal@us.ibm.com> wrote:

> Mike Snitzer [snitzer@redhat.com] wrote:
> > Refreshed Hannes' initial "scsi: Detailed I/O errors" patch against
> > v2.6.37-rc5.  v2 introduces __scsi_error_from_host_byte to avoid
> > the duplicate switch statement.  Also a few whitespace and comment
> > changes.
> > 
> > Split DM mpath change out to separate v2 patch; failed discard is now
> > retryable in the face of a non-target IO error.
> > 
> > Added improved block layer's I/O error message (based on the finer
> > grained I/O error returns afforded by SCSI).
> > 
> > Comments/suggestions are welcome.
> 
> I did test the Hannes original patch with the latest Linus' git tree! I
> used scsi_debug to simulate path failures as well as 'Media' failures
> and it did work as expected. I will test your patches soon.

Hi Malahal,

I was wondering if you had any feedback (testing or otherwise) for these
patches:

https://patchwork.kernel.org/patch/384612/
https://patchwork.kernel.org/patch/384602/
https://patchwork.kernel.org/patch/390882/

We haven't heard from Hannes in a bit but I was hoping we could at least
understand that the few changes I made are agreeable and working as
expected.

Thanks,
Mike
