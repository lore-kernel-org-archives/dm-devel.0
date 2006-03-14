From: Zach Brown <zab@zabbo.net>
Subject: target that injects errors?
Date: Mon, 13 Mar 2006 18:53:06 -0800
Message-ID: <44163012.8020007@zabbo.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I find myself wanting to test a patch that reacts to EIO deep in aio
O_DIRECT.  Has anyone done a target that can inject errors into the IO
path?  I found sct's "testdrive", but it seems a bit crufty these days:

  http://people.redhat.com/sct/patches/testdrive/

If someone hasn't done this, I'll take a swing at it.

Thanks.

- z
