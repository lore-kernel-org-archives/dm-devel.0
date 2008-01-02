From: Brian De Wolf <bldewolf@csupomona.edu>
Subject: Re: device mapper configurations
Date: Wed, 02 Jan 2008 10:19:21 -0800
Message-ID: <477BD5A9.4000501@csupomona.edu>
References: <477B9DE9.3090108@oranged.to>
	<000101c84d4f$9510cb00$06000100@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000101c84d4f$9510cb00$06000100@pitagora.it>
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

Domenico Viggiani wrote:
>> -----Original Message-----
>> From: dm-devel-bounces@redhat.com 
>> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Jimmy Stewpot
>> Sent: Wednesday, January 02, 2008 3:21 PM
>> ...
>> When the system boots I get loads of errors that look like this
>>
>> [  217.140126] end_request: I/O error, dev sdb, sector 0 [  
>> ...
>>
>> When the servers boot up. The items being reported are the 
>> underlying scsi devices which we have setup above. Is it 
>> normal to get these messages or do I need to explicitly place 
>> the underlying devices into the blacklist?
> 
> You have an active-passive array (like my EMC Clariion) and these messages
> are normal even if annoying. It's not much "professional".
> With Clariion, as far as I know, the only solution is upgrading Flare to
> ver. 26 that simulates active-active behaviour.

They should be expected, since you can't read the passive link, but it's only
failing on sector 0 which sounds like udev is trying to read the partition
table.  I think I remember fixing this behavior on a test box (that's long gone,
now, so I can't look it up) by fiddling with the udev rules to not bother
scanning the multipathed (i.e. fiber channel) devices.

Sorry for the lack of specifics, but it's been a while, and I wasn't very
specific in my own notes about what I did.  They should be preventable, though,
if I remember right.
