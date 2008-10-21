From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Calltrace in dm-snapshot in 2.6.27 kernel
Date: Tue, 21 Oct 2008 13:22:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0810211319330.13319@hs20-bc2-1.build.redhat.com>
References: <48FC23DE.5040000@poczta.onet.pl> <48FC4498.5070706@redhat.com>
	<48FD7911.1000705@poczta.onet.pl>
	<Pine.LNX.4.64.0810210953560.12983@hs20-bc2-1.build.redhat.com>
	<48FDFF53.5080007@poczta.onet.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48FDFF53.5080007@poczta.onet.pl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: aluno3 <aluno3@poczta.onet.pl>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Hi Mikulas
> 
> I send to You (in attachment) files from both kernels.Thank You for help
> 
> Best

Thanks. Does your workload involve just one snapshot of a given volume, or 
do you have more snapshots of the same volume? Do you write only to origin 
or to both origin and the snapshot or only to the snapshot?

I will send you some patch with more debug tests soon, just answer these 
questions first, so that I can make it.

Mikulas
