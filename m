From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: no_path_retry question
Date: Thu, 1 Feb 2007 20:17:16 -0600
Message-ID: <20070202021716.GA3141@ether.msp.redhat.com>
References: <OFA96391CF.1F30E02D-ON87257274.007B864A-87257274.007BD911@seagate.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OFA96391CF.1F30E02D-ON87257274.007B864A-87257274.007BD911@seagate.com>
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

On Wed, Jan 31, 2007 at 03:32:43PM -0700, Dale.R.Fowle@seagate.com wrote:
> 
> Hi all, I have a question on what the retry in the no_path_retry option
> refers to. If we use a number like 60, instead of "fail" or "queue", does
> Multipath Tools retry an IO at one second intervals? Or is this retry based
> off of the SCSI timeout value within the kernel?

It refers to the number of times that multipath will check for a path before
failing. So it is approximately no_path_retry * polling_interval seconds.

-Ben
> 
> Thanks,
> Dale
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
