From: malahal@us.ibm.com
Subject: Re: Use device mapper to redirect to cache server?
Date: Tue, 8 Jan 2008 11:30:42 -0800
Message-ID: <20080108193042.GA6223@us.ibm.com>
References: <200801081030.20172.philipp.marek@bmlv.gv.at>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200801081030.20172.philipp.marek@bmlv.gv.at>
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
Cc: philipp.marek@bmlv.gv.at
List-Id: dm-devel.ids

Ph. Marek [philipp.marek@bmlv.gv.at] wrote:
> Hello everybody!
> 
> 
> I'd like to mirror write accesses to a block-device to two devices, get all 
> all *read* accesses from one of these, and if it fails, to fallback to the 
> other device.

This is exactly what 'mirror' target does (dm-raid1.c) without
read-balancing. But read on...

> The usage would be to use some kind of NAS box as persistent network block 
> device, with some other machine with a lot of RAM as cache server; the cache 
> server would get asked for data, and if it's not available, the request 
> should go to the NAS directly.

I think, you are better of using the cache server as some kind of NFS
server as 'mirror' target's failure handling is heavy-weight.
