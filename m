From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: poor thin performance, relative to thick
Date: Fri, 15 Jul 2016 14:59:07 -0400
Message-ID: <20160715185906.GA29580@redhat.com>
References: <20160711204454.GA24378@helmut> <20160712184625.GA3691@redhat.com>
	<20160714042122.GB24221@helmut>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160714042122.GB24221@helmut>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jon Bernard <jbernard@tuxion.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 14 2016 at 12:21am -0400,
Jon Bernard <jbernard@tuxion.com> wrote:
 
> Do you have any intuition on where to start looking?

Joe asked me a very basic/obvious question: is block zeroing enabled?
(block zeroing is enabled by default -- you have to know to disable it)

If zeroing wasn't disabled that could explain some of the sizable
performance differences.  Please use/test the 'skip_block_zeroing'
feature if you aren't already (also see the "Zeroing' section of the
'lvmthin' manpage).

Mike
