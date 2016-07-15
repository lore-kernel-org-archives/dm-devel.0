From: Jon Bernard <jbernard@tuxion.com>
Subject: Re: poor thin performance, relative to thick
Date: Fri, 15 Jul 2016 16:57:21 -0400
Message-ID: <20160715205721.GA4948@helmut>
References: <20160711204454.GA24378@helmut> <20160712184625.GA3691@redhat.com>
	<20160714042122.GB24221@helmut> <20160715185906.GA29580@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160715185906.GA29580@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

* Mike Snitzer <snitzer@redhat.com> wrote:
> On Thu, Jul 14 2016 at 12:21am -0400,
> Jon Bernard <jbernard@tuxion.com> wrote:
>  
> > Do you have any intuition on where to start looking?
> 
> Joe asked me a very basic/obvious question: is block zeroing enabled?
> (block zeroing is enabled by default -- you have to know to disable it)

Ah, I failed to mention that I did read about that in the manpage and
disabled it.  Just to be sure, here is my lvs output:

# lvs -o +zero
  LV        VG   Attr       LSize   Pool  Origin Data%  Meta%  Move Log Cpy%Sync Convert Zero   
  pool1     thin twi-aot---   1.00t              9.77   0.35                                    
  pool2     thin twi-aot---   1.00t              0.00   0.03                                    
  thick     thin -wi-a----- 100.00g                                                      unknown
  thindisk1 thin Vwi-a-t--- 100.00g pool1        100.00                                  unknown

I believe we'd see a 'z' in attr field if it were enabled.
 
> If zeroing wasn't disabled that could explain some of the sizable
> performance differences.  Please use/test the 'skip_block_zeroing'
> feature if you aren't already (also see the "Zeroing' section of the
> 'lvmthin' manpage).

If my understanding is correct, even with zeroing enabled, my initial
sequential write that that caused the volume to become fully allocated
would have alleviated any further zeroing during the random write test.

-- 
Jon
