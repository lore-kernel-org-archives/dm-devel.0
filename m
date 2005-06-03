From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] HP storageworks-like hwhandler
Date: Fri, 03 Jun 2005 11:32:45 -0700
Message-ID: <42A0A24D.7040702@cs.wisc.edu>
References: <20050603182906.GB10178@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050603182906.GB10178@averon.dyndns.org>
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

Christophe Varoqui wrote:
> Hello,
> 
> I repackaged Dave Olien's scsi-start hwhandler to try to give it a wider audience.
> It now compiles out-of-tree, and builds fine on RHEL4U1 kernel.
> 
> This hwhandler is targeted at a family of assymmetric arrays like HP StorageWorks and FSC FibreCat that take a START_STOP SCSI cmd as a sign of the host willing to initiate a LUN failover.
> 
> It would be good to have this code undusted and endorsed by HP ... before RHEL4U2 freezes.
> Seems a good topic for the next conf call :/
> 
> You can find the tarball there :
> http://christophe.varoqui.free.fr/multipath-tools/dm-scsi-start.tar.gz
>

This looks like his old code which had several problems. I think he 
fixed them up. Is there a new version?
