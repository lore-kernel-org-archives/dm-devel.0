From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Infinite recursion when creating devices
Date: Wed, 29 Feb 2012 14:50:06 +0000
Message-ID: <20120229145006.GF24997@agk-dp.fab.redhat.com>
References: <4F4E34C7.7070005@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F4E34C7.7070005@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

You need sysadmin privileges to do this and I reckon that offers many
other ways of causing crashes too:)

It didn't seem worth attempting to prevent all device loops as it's not
a cheap thing to detect and not something likely to occur in practice. 

Nevertheless, some userspace tools do contain some checks to avoid some
cases like this already.

Alasdair
