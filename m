From: Tore Anderson <tore@linpro.no>
Subject: Re: Changing SAN vendors
Date: Fri, 06 Feb 2009 08:41:09 +0100
Message-ID: <498BE995.7080406@linpro.no>
References: <4905EFD192EEDF4A9A19EEE98C32B7F70EFB4A29@DBQV3005.na.corp.mckesson.com>
	<4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com>
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

* Allen, Jack

>     The Answer: The friendly names are kept in
> /var/lib/multipath/bindings. Because the WWID changed multipathd created
> new entries. All I had to do was remove the entries for the old WWID and
> change the friendly name for the new WWID. Simple, but hard to locate
> the file when no documents I could find to begin with tells you that is
> where the friendly names are kept.
> 
>     The Question: The first system was running RH EL 5.2, but the next
> system is running RH AS 4.7. There was no /var/lib/multipath directory,
> therefore no bindings file. So I created both, and entered mpath0 and
> mpath1 with the WWID, but it still uses mpath2 and mpath3. I know
> multipathd are different version between the two RH Release. Is there
> something else I need to change on the RH AS 4.7 system to make it use
> the mpath0 and mpath1 names?

I suggest you configure the names statically in /etc/multipath.conf
instead, this will work in both RHEL 4 and 5.  This will also allow you
to give the devices more descriptive names than just "mpathN".  For
instance:

multipaths {
  multipath {
    wwid 36006016034301f00b8934c11c241dd11
    alias oracle
  }
  multipath {
    wwid 36006016034301f001c578c8bab21dd11
    alias varwww
  }
}

Regards,
-- 
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
