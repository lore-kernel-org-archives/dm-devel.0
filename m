From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Buffer I/O errors
Date: Tue, 2 May 2006 14:14:46 -0700
Message-ID: <20060502211446.GA30834@us.ibm.com>
References: <4454A5CC.20108@telkomsa.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4454A5CC.20108@telkomsa.net>
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

Niel Lambrechts <antispam@telkomsa.net> wrote:
> Buffer I/O error on dm-0
> Lost page write due to I/O error
> reiserfs: dm-0 journal write error in flush_commit_list
> 

There should be a few scsi error messages in the log prior to "Buffer I/O
error on dm-0" that would provide info on why the scsi command did not
complete. This will answer all your failure isolation questions, but it
will help narrow it down to the next level.

-andmike
--
Michael Anderson
andmike@us.ibm.com
