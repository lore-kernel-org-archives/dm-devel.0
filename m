From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-verity: Verification fails but do not
	see	Input/Output Error on read
Date: Thu, 8 Aug 2013 13:18:58 +0100
Message-ID: <20130808121858.GB31819@agk-dp.fab.redhat.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chaitra Bhat <Chaitra.Bhat@verifone.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 08, 2013 at 09:01:44AM +0000, Chaitra Bhat wrote:
> So, any idea why do I not get Input/Output Error message when I know that verification is failing at that location?

I think it only verifies the data the first time it is read and doesn't check
for changes underneath while the device is live.

Alasdair
