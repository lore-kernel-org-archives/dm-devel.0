From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: for-next hangs on test srp/012
Date: Tue, 11 Dec 2018 15:09:27 -0800
Message-ID: <1544569767.185366.393.camel@acm.org>
References: <1544569107.185366.391.camel@acm.org>
	<20181211230514.GA20445@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4818049325389932531=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181211230514.GA20445@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============4818049325389932531==
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit

On Tue, 2018-12-11 at 18:05 -0500, Mike Snitzer wrote:
+AD4 On Tue, Dec 11 2018 at  5:58pm -0500,
+AD4 Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4 wrote:
+AD4 
+AD4 +AD4 Hi Jens,
+AD4 +AD4 
+AD4 +AD4 If I run the following subset of blktests:
+AD4 +AD4 
+AD4 +AD4   while :+ADs do ./check -q srp +ACYAJg ./check -q nvmeof-mp+ADs done
+AD4 +AD4 
+AD4 +AD4 against today's for-next branch (commit dd2bf2df85a7) then after some
+AD4 +AD4 time the following hang is reported:
+AD4 
+AD4 Jens has applied a fix from me today that I think is very relevant+ADs
+AD4 it'll be in tomorrow's for-next:
+AD4 
+AD4 http://git.kernel.dk/cgit/linux-block/commit/?h+AD0-for-4.21/block+ACY-id+AD0-c4576aed8d85d808cd6443bda58393d525207d01
+AD4 
+AD4 Please try with that and see how things go.

Hi Mike,

Thank you for your reply. I should have mentioned that I used Jens' for-next
branch as starting point and that that commit is present in the branch I used
as a starting point for my tests:

+ACQ git branch --contains c4576aed8d85d808cd6443bda58393d525207d01    
+ACo axboe-block-for-next

Bart.


--===============4818049325389932531==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4818049325389932531==--
