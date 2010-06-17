From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 2.6.35 causes deadlock when snapshotting root lv
Date: Thu, 17 Jun 2010 12:16:52 -0400
Message-ID: <4C1A4A74.9070105@cfl.rr.com>
References: <4C1A2839.5010407@cfl.rr.com> <20100617142731.GA10071@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100617142731.GA10071@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 6/17/2010 10:27 AM, Mike Snitzer wrote:
> Which filesystem are you using?  Which 2.6.35-rc?

ext4, rc1, 2, and 3.

> There haven't been _any_ changes to DM for 2.6.35 (some DM fixes may get
> pushed to Linus once Alasdair gets back from traveling).

I just finished combing through the git log myself and was getting
concerned that I couldn't find any dm changes.  At least now I know that
I couldn't find them because they aren't there.

> So what this means is that the VFS (or ext4) freeze changes introduced
> in 2.6.35 are the likely culprit:
> 
> http://git.kernel.org/linus/18e9e5104fcd9a9
> http://git.kernel.org/linus/6b0310fbf087ad6

Yes, these do look suspicious.  I'll test reverting them tonight.
