From: Brian Wong <bwong@pillardata.com>
Subject: Re: Requiring a hwtable entry for a dm target device?
Date: Thu, 15 Dec 2005 14:53:12 -0800
Message-ID: <1134687192.8409.5.camel@ca-bwong3.trans.corp>
References: <C2EEB4E538D3DC48BF57F391F422779321AEB9@srmanning.eng.emc.com>
Reply-To: bwong@pillardata.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AEB9@srmanning.eng.emc.com>
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

On Thu, 2005-12-15 at 16:29 -0500, egoggin@emc.com wrote:
> Currently a dm target device which is not blacklisted need not have a
> corresponding hwentry in either libmultipath/hwtable.c or
> /etc/multipath.conf
> for the target device to be recognized and a multipath mapped device
> created for it.  Is this desirable, possibly for multipathing to JBOD?

yes, it is desirable.  i think the intent is that all reasonably
standards-conformant products should "just work", without needing to
provide special configuration stanzas in .conf files, or, worse yet,
actual source code as system administrators are even less eager to touch
those than conf files.

> 
> An alternative is to require that a hwentry be found and fail to recognize
> the target device otherwise.  Doing so has the distinct advantage of being
> able to use the regular expression matching logic in find_hwe() to
> effectively
> blacklist a target device based on the contents of the target device's
> vendor
> and product device attributes.
> 

i don't understand why it is important to exclude devices from being seen.  doesn't it make more+sense to be able to see as many legitimate devices as possible?  If that's not desirable, isn't there already a way to blacklist devices in the .conf file?
