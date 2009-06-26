From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: failover does not work with rdac device handler
Date: Fri, 26 Jun 2009 10:41:23 -0700
Message-ID: <1246038083.14164.17.camel@chandra-ubuntu>
References: <4A424F9E.1050403@meteo.uni-koeln.de>
	<Pine.LNX.4.64.0906241621450.22601@e-smith.charlieb.ott.istop.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906241621450.22601@e-smith.charlieb.ott.istop.com>
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


On Wed, 2009-06-24 at 16:29 -0400, Charlie Brady wrote:
> On Wed, 24 Jun 2009, Mario Mech wrote:
> 
> > I need help with a similar or even the same issue as in the thread mentioned 
> > in the Subject 
> > (https://www.redhat.com/archives/dm-devel/2008-October/msg00130.html).
> 
> I have the same issue occurring with a Sun StorageTek 2510 (iscsi 
> storage array whose details and multipath.conf configuration I provided 
> recently). AFAICS, the symptoms are identical.
> 
> It seems that it would be useful to be able to extend rdac_dev_list at 
> module load time (e.g. via options in modprobe.conf). Thoughts?

That is a good idea. Let me think about it. 

OTOH, if you can roll up a patch, I will be happy to review :)
> 
> ---
> Charlie
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
