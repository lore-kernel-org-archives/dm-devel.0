From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Changing SAN vendors
Date: Fri, 13 Feb 2009 10:28:47 +0000
Message-ID: <49954B5F.5080209@redhat.com>
References: <4905EFD192EEDF4A9A19EEE98C32B7F70EFB4A29@DBQV3005.na.corp.mckesson.com>	<4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com>
	<4905EFD192EEDF4A9A19EEE98C32B7F70F3EB744@DBQV3005.na.corp.mckesson.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4905EFD192EEDF4A9A19EEE98C32B7F70F3EB744@DBQV3005.na.corp.mckesson.com>
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

Allen, Jack wrote:
> Hello:
>     Still looking for an answer for RH AS 4.7.
>  
>     No body has any ideas?

The mpath names change because the XP is exporting the storage with 
new WWIDs (multipath-tools name binding is all based on LUN WWIDs). 
The bindings are stored in a file that is normally automatically 
generated and maintained.

I think in your stiuation if you need to preserve the old names, your 
best option is to manually edit the bindings file and copy it between 
the hosts that need to have a common view of the storage.

The default location for the file is /var/lib/multipath/bindings, 
although if you have /var configured as a separate file system you 
should move it to /etc and configure the bindings_file option in 
multipath.conf to avoid problems when initialising multipath devices 
before /var is mounted.

You could also take the steps that Tore suggested and configure 
multipath entries in multipath.conf to map the devices but unless you 
are happy with giving them new names this isn't going to work as the 
current multipath-tools will give undefined behaviour if you use 
"mpathN" style names for aliases defined in multipath.conf.

Regards,
Bryn.
