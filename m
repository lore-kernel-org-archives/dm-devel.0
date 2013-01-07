From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: use WRITE_FLUSH instead of REQ_FLUSH
Date: Mon, 7 Jan 2013 09:23:49 -0500
Message-ID: <20130107142348.GA5097@redhat.com>
References: <Pine.LNX.4.64.1301070009230.7490@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1301070009230.7490@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 07 2013 at 12:12am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi Alasdair
> 
> Please push this patch to 3.8 kernel. (I already sent it before, but it 
> was forgotten somehow).
> 
> Mikulas
> 
> ---
> 
> dm-bufio: use WRITE_FLUSH instead of REQ_FLUSH
> 
> Use WRITE_FLUSH instead of REQ_FLUSH to make it consistent with the rest
> of the kernel. There is no functional change - the kernel accepts either
> WRITE_FLUSH or REQ_FLUSH.

Well the important distinction is the flush bio is originating in
dm-bufio whereas other DM targets that test for REQ_FLUSH are just
passing the flush through.  Saying as much makes the need for this patch
more explicit.
