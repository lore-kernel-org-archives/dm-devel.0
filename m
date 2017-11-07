From: Joe Thornber <thornber@redhat.com>
Subject: Re: Significantly dropped dm-cache performance in 4.13
 compared to 4.11
Date: Tue, 7 Nov 2017 14:41:57 +0000
Message-ID: <20171107144157.6yng4owvmmcm33qj@reti>
References: <CAAxjCExHqssZ8vuCC19_NP1io=StFAYk48nqDfudhjD-PyLZCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAAxjCExHqssZ8vuCC19_NP1io=StFAYk48nqDfudhjD-PyLZCg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 03, 2017 at 07:50:23PM +0100, Stefan Ring wrote:
> It strikes me as odd that the amount read from the spinning disk is
> actually more than what comes out of the combined device in the end.

This suggests dm-cache is trying to promote too way too much.
I'll try and reproduce the issue, your setup sounds pretty straight forward.

- Joe
