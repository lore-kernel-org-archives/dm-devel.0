From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-cache invalidate_cblocks range parsing
Date: Tue, 26 Nov 2013 16:39:47 +0000
Message-ID: <20131126163947.GK27771@agk-dp.fab.redhat.com>
References: <33A0129EBFD46748804DE81B354CA1B21C0532E5@SACEXCMBX06-PRD.hq.netapp.com>
	<20131125224618.GG27771@agk-dp.fab.redhat.com>
	<20131126162046.GA27431@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131126162046.GA27431@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

None of which answers the point that some of the people seeing such a
range might well interpret it incorrectly and find the correct
interpretation surprising.  I am strongly of the view that interfaces
like these should be designed to minimise the risk of ambiguity or
misinterpretation by people who didn't read all the documentation and I
still think this interface should be changed.  The advantage of the "+"
approach is that it is unusual and more likely therefore to force people
to check the documentation rather than unknowingly making an incorrect
assumption about what "-" means.

Alasdair
