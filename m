From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: Question about multipath device compiled defaults
Date: Wed, 20 Jan 2016 15:47:57 -0200
Message-ID: <569FC84D.4070301@linux.vnet.ibm.com>
References: <201511050700.tA570XNA029270@d06av02.portsmouth.uk.ibm.com>
	<569E65D4.4020002@linux.vnet.ibm.com>
	<CABr-GneOyHJNiQRywzdKq5rr5S7Ljz4up3W=V_HgHoUtfY=C3g@mail.gmail.com>
	<CAHZQxyLmSQq89=P4b+rehQhWtU8eC4KO4rxaPzmDv5uZ0p7B2A@mail.gmail.com>
	<CABr-Gndqm+7cgExV4eMfHiXkerj87X30BVi=OP_7Oo-16Od8-Q@mail.gmail.com>
	<CAHZQxyLc3Sn5ycm3YCyVQEA10+rqer1_bmcRrODLrxTh+R1GwQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAHZQxyLc3Sn5ycm3YCyVQEA10+rqer1_bmcRrODLrxTh+R1GwQ@mail.gmail.com>
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
Cc: brian@purestorage.com
List-Id: dm-devel.ids

Hi Brian,

On 01/20/2016 02:15 PM, Brian Bunker wrote:
> Any ideas how long it typically takes the distros like RHEL, etc. to
> pull these changes down, or do they need to be pinged explicitly that
> there are changes available that we want them to consider?

It's a good idea to let them know (e.g., bug/feature report).
I've worked a bit w/ Ubuntu, RHEL, and SLES.

Even though the changes might eventually make downstream, some distros
won't pull everything (reasonably), but only the pieces they find/know
to be required or desired by users/customers -- specially on released/
stable distro versions.

So, letting them know / ask for consideration usually helps.

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
