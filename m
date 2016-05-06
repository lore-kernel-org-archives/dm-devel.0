From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 6/6] libmultipath: fixup dm_rename
	to	complete cookie on failure
Date: Fri, 6 May 2016 22:59:01 +0100
Message-ID: <20160506215900.GA28251@agk-dp.fab.redhat.com>
References: <1462341450-5507-1-git-send-email-hare@suse.de>
	<1462341450-5507-7-git-send-email-hare@suse.de>
	<20160506202920.GW26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506202920.GW26117@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The library functions and return states are supposed to be well-defined.

If you think you've found a cookie leak on an error path within a library
function, we can investigate that and fix the library if need be.

Alasdair
