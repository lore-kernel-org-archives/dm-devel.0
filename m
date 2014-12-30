From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: Hibernate/Resume and dm-cache, dm-writeboost...
Date: Tue, 30 Dec 2014 20:34:23 +0900
Message-ID: <54A28DBF.9060909@gmail.com>
References: <549B0785.3060807@rolffokkens.nl> <20141230103228.GA31888@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141230103228.GA31888@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: kmo@daterainc.com, mathijs@bluescreen303.nl
List-Id: dm-devel.ids

Hi, I am the developer of DM-Writeboost.

I am not sure what the problem is. Is the problem caching driver
may update the underlying devices before resume?

If so, stopping daemons will do by sending the driver these messages
- allow_writeback 0
- enable_writeback_modulator 0
- update_record_interval 0
The first two stops writeback and the third one stops periodical
update of the superblock sector.

btw, DM-Writeboost isn't in LVM family yet so this problem won't happen
at the moment however, I doesn't mean I can be unaware. Thanks.

- Akira
