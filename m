From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Subject: Use device mapper to redirect to cache server?
Date: Tue, 8 Jan 2008 10:30:19 +0100
Message-ID: <200801081030.20172.philipp.marek@bmlv.gv.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758239AbYAHJax@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello everybody!


I'd like to mirror write accesses to a block-device to two devices, get all 
all *read* accesses from one of these, and if it fails, to fallback to the 
other device.


The usage would be to use some kind of NAS box as persistent network block 
device, with some other machine with a lot of RAM as cache server; the cache 
server would get asked for data, and if it's not available, the request 
should go to the NAS directly.

If I read the multipath documentation correctly (at 
http://christophe.varoqui.free.fr/multipath.html):
	For completion, here is an example of a pure failover target definition for
 	the same LU :
	...
multipath should do part of what I want - use another device if the first one 
fails.
But that doesn't account for pushing writes to both; and how is failing 
defined for NBD? I don't see some configurable timeout.


Thank you for all ideas/suggestions! [[ but please CC me ]]


Regards,

Phil
