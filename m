From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 0/3] freeze feature ver 1.6
Date: Wed, 25 Jun 2008 23:53:19 +0100
Message-ID: <20080625225319.GR22522@agk.fab.redhat.com>
References: <1c748a490806251445x4c1f4901nb503273b08dd680@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1c748a490806251445x4c1f4901nb503273b08dd680@mail.gmail.com>
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
List-Id: dm-devel.ids

You could experiment adding the dm 'delay' target into your device stack,
which lets you route reads and writes down different paths - then have 
separate linear targets underneath each recombining them back into
the same path, and then use the existing dmsetup suspend/resume only on the
read path.

Alasdair
-- 
agk@redhat.com
