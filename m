From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Device-mapper cluster locking
Date: Wed, 7 Apr 2010 20:07:55 +0100
Message-ID: <20100407190755.GF511@agk-dp.fab.redhat.com>
References: <1270648258.25738.18.camel@hydrogen.msp.redhat.com>
	<Pine.LNX.4.64.1004071332130.20373@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1004071332130.20373@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

That's the point I queried about whether or not it used a NULL lock -
hands the decision about when/if to free resources over to the dlm.

Alasdair
