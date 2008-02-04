From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: SLES installation on dual controller subsystem
Date: Mon, 4 Feb 2008 15:58:52 -0800
Message-ID: <110b17190802041558y6b30e000x5a3e530f4c717d4e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi All,

I am trying to install SLES 10.1 on my dual controller subsystem. The
subsystem is ALUA aware and hence shows me 2 LUNs for one while trying
to install SLES on it.

If my LUN's preferred controller is 1 then everything goes fine, but
if the preferred controller of the LUN I am installing OS on is 2,
then installation goes fine but the boot fails.

It throws some errors like root (hd1,1) could not found. When I modify
this to too(hd0,1) it boots fine.

What am I missing here?

Regards,
Pradipmaya.
