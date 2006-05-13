From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] Remove softlockup from
	invalidate_mapping_pages. (might be dm related)
Date: Sat, 13 May 2006 23:37:30 +0100
Message-ID: <20060513223730.GT16180@agk.surrey.redhat.com>
References: <20060426204809.GA15462@uio.no>
	<20060426135809.10a37ec3.akpm@osdl.org>
	<20060513134908.GA4480@uio.no>
	<20060513073344.4fcbc46b.akpm@osdl.org>
	<20060513144334.GA6013@uio.no>
	<20060513075147.423d18bd.akpm@osdl.org>
	<20060513150003.GA6096@uio.no>
	<20060513082409.4d173ccc.akpm@osdl.org>
	<20060513153231.GA6277@uio.no>
	<20060513084317.50356155.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060513084317.50356155.akpm@osdl.org>
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
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

What's the device configuration here:
   e.g. linear dm logical volume over md raid5?

[e.g. post output of dmsetup info -c' and 'dmsetup table'
and 'dmsetup status' remembering to blank out the
long hex string if you have dm-crypt]

Alasdair
-- 
agk@redhat.com
