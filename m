From: aluno3 <aluno3@poczta.onet.pl>
Subject: Re: Calltrace in dm-snapshot in 2.6.27 kernel
Date: Tue, 21 Oct 2008 20:42:40 +0200
Message-ID: <48FE22A0.30005@poczta.onet.pl>
References: <48FC23DE.5040000@poczta.onet.pl> <48FC4498.5070706@redhat.com>
	<48FD7911.1000705@poczta.onet.pl>
	<Pine.LNX.4.64.0810210953560.12983@hs20-bc2-1.build.redhat.com>
	<48FDFF53.5080007@poczta.onet.pl>
	<Pine.LNX.4.64.0810211319330.13319@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0810211319330.13319@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

My workload in case of 32b involved only one volume and 3 snapshots to
this volume. I wrote only to origin volume (with use fstress) and I
created and deleted these snapshots from time to time. Snapshots was
mount with rw option.

In case 64b I had 2 volume and 10 snapshots for each volume.I created
and deleted these snapshots from time to time as well. I wrote only to
origin volumes (with use dd)

I don`t remember exactly but in case test with 1 snapshot per volume all
was working correctly through a few hours and I stopped this test but in
case my above tests system was working correctly through a few minutes.
 
Mikulas Patocka wrote:
>> Hi Mikulas
>>
>> I send to You (in attachment) files from both kernels.Thank You for help
>>
>> Best
>>     
>
> Thanks. Does your workload involve just one snapshot of a given volume, or 
> do you have more snapshots of the same volume? Do you write only to origin 
> or to both origin and the snapshot or only to the snapshot?
>
> I will send you some patch with more debug tests soon, just answer these 
> questions first, so that I can make it.
>
> Mikulas
>
>   
