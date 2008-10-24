From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: multipathd segfault and SCSI errors
Date: Fri, 24 Oct 2008 09:30:41 -0400
Message-ID: <20081024133041.GA28671@mars.virtualiron.com>
References: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1@mailx.jigsaw.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1@mailx.jigsaw.com>
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

> multipathd[7165]: segfault at 000000000000000a rip 00002aaaaaf51a3d rsp 00007fff03b50090 error 4

Can you run multipathd as so:

multipathd -v9 -d

And provide the -200 lines output from the segfault output? You might need to
edit the /etc/init.d/multipathd to have this work and pipe the output to a log file or so.
