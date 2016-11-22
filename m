From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] New device mapper target ZDM
Date: Tue, 22 Nov 2016 15:44:30 +0000
Message-ID: <20161122154430.GA22270@agk-dp.fab.redhat.com>
References: <20161121192311.14539-1-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20161121192311.14539-1-shaun@tancheff.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shaun Tancheff <shaun@tancheff.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Vineet Agarwal <vineet.agarwal@seagate.com>, dm-devel <dm-devel@redhat.com>, Michael T Lombardi <michael.t.lombardi@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Well to start with some device-mapper basics, looks at the newer files
(e.g.  thin-provisioning.txt, cache.txt) in the Documentation directory
to see what format to use and how to document the interface.
Constructor, status, examples using dmsetup only etc.

(BTW We don't use equals signs in our interfaces.)

But even before any of that, I'm puzzled by the basics of how this can
have been fitted into a device-mapper interface where the "sine qua non"
resume function is still TODO, 'dmsetup table' appears unimplemented,
'status' doesn't appear to provide the internal status, and 'load' has
some keywords that also don't appear to fit.

Look at how the existing dm targets divide up the work between each of
the functions and model your interface on those.

Alasdair
