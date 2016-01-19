From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: Question about multipath device compiled defaults
Date: Tue, 19 Jan 2016 14:35:32 -0200
Message-ID: <569E65D4.4020002@linux.vnet.ibm.com>
References: <201511050700.tA570XNA029270@d06av02.portsmouth.uk.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201511050700.tA570XNA029270@d06av02.portsmouth.uk.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: DORONTAL@il.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/05/2015 04:59 AM, Doron Tal1 wrote:
> I would like to know how and what procedure i should follow if i want to
> modify or add new settings to the device mapper defaults.

The defaults are in hwtable.c [1].

> So for example how can i modify existing compiled settings for the
> 2810XIV device? in case i want to add a new device and it settings, how
> can it be done?

To modify the compiled settings, you have to modify it and recompile.

To modify the runtime settings (based on the defaults), you can modify
/etc/multipath.conf (see its manpage [2] with 'man multipath.conf').

You can verify the the setting values used during multipath discovery
with 'multipath -v3' for example, or "multipathd -k'show config'".

Hope this might still help at this time,

[1] 
http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/hwtable.c
[2] 
http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=multipath/multipath.conf.5

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
