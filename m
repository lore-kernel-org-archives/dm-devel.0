From: Joe Thornber <thornber@redhat.com>
Subject: Re: Proposition for zeroed logical volume
Date: Thu, 30 Jun 2011 09:06:30 +0100
Message-ID: <20110630080629.GB3523@ubuntu>
References: <Pine.LNX.4.64.1106292221420.18144@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106292221420.18144@hs20-bc2-1.build.redhat.com>
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
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 29, 2011 at 10:24:14PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I placed proposition for zeroed logical volume target interface here:
> 
> http://people.redhat.com/mpatocka/text/zero-volume.txt

We have a bugzilla for exactly this already.  However we've been
vassilating as to how urgent it is.

One of the arguments against it is that this functionality can be
provided by the mirror target.  For example having one leg be a simple
'all zeroes' target, and the other your the volume that you want to be
zeroed.

- Joe
