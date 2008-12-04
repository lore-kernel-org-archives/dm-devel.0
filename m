From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: dm targets with spaces in the name
Date: Thu, 4 Dec 2008 15:15:51 -0500
Message-ID: <49383A77.80903@cfl.rr.com>
References: <4936BBC6.7000800@cfl.rr.com> <1228405956.23557.74.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1228405956.23557.74.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Heinz Mauelshagen wrote:
> What you describe here, is essentially caused by bogus names in vendor
> metadata not being detected and handled properly by dmraid.
> 
> Which metadata format is that being caused by ?

isw

> Can you send me the metadata sample retrieved via "dmraid -rD"
> (bzip2/tar the resulting *.{dat,offset,size} files before sending) ?

See https://bugs.launchpad.net/ubuntu/+source/dmraid/+bug/299311

and

http://launchpadlibrarian.net/19744950/dmraid%20dump.tar.gz

Basically the user named his volume "Mother Brain 2" when he created it 
in the bios, so dmraid tries to create the target "isw_cfebfidbf_Mother 
Brain 2" which works, but then it can't use that device as the target 
for the partition linear mapping "isw_cfebfidbf_Mother Brain 21" ( that 
would be "2p1" but for some reason debian/ubuntu have a patch that 
removes the p ).

>> So should you just avoid doing this,
> 
> Yes, whitespace is not to be supported in mapped device names.

Why not?  File names with spaces in them are valid, even for dev nodes. 
  I can use dmsetup to create a device with a space in the name.  It 
seems like it should then be valid to use that device as a target in 
another one.

>> or should the kernel be fixed to 
>> understand quotes or backslash escapes or something to allow spaces in 
>> the target device file name?
> 
> No M$ worries, please ;)

Not sure what you mean there, but I actually took a look at the kernel 
code, and it was failing to parse the correct number of arguments, but 
it looks like dm_split_args() DOES understand backslash escaping.  When 
I backslash escape the spaces in the name, it appears to parse the 
correct number of arguments, yet linear_ctr() still fails with "Device 
lookup failure".
