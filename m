From: christophe varoqui <christophe.varoqui@free.fr>
Subject: number of io before switching path param
Date: Sun, 12 Jun 2005 14:18:35 +0200
Message-ID: <1118578715.20754.54.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hello,

I've got a hard time understanding why the number of io before switching
path in a path group is a path parameter instead of a round-robin
selector one.

Imagine we have a least-queued-io selector, would this path parameter
make any sense ?

Id like the multipath tool to reload a map when this param changes in
the config file ... Can we sort this out before I start coding this.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
