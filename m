From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: RE: failover does not work with rdac device handler
Date: Wed, 24 Jun 2009 16:29:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906241621450.22601@e-smith.charlieb.ott.istop.com>
References: <4A424F9E.1050403@meteo.uni-koeln.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A424F9E.1050403@meteo.uni-koeln.de>
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


On Wed, 24 Jun 2009, Mario Mech wrote:

> I need help with a similar or even the same issue as in the thread mentioned 
> in the Subject 
> (https://www.redhat.com/archives/dm-devel/2008-October/msg00130.html).

I have the same issue occurring with a Sun StorageTek 2510 (iscsi 
storage array whose details and multipath.conf configuration I provided 
recently). AFAICS, the symptoms are identical.

It seems that it would be useful to be able to extend rdac_dev_list at 
module load time (e.g. via options in modprobe.conf). Thoughts?

---
Charlie
