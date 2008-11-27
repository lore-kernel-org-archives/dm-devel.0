From: Matthew Kent <matt@bravenet.com>
Subject: path_checker within multipath {}
Date: Thu, 27 Nov 2008 11:47:54 -0800
Message-ID: <1227815274.4344.54.camel@fuego>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Am I missing something obvious here?

/usr/share/doc/device-mapper-multipath-0.4.7/multipath.conf.annotated
says this should work, and I can't find a RHEL 5 issue for it:

My config says:

multipaths {
        multipath {
                wwid "22263000155ada9e9"
                path_grouping_policy failover
                path_checker tur
        }
        multipath {
                wwid "36090a018108277e8ed92e4e9cee1733e"
                path_grouping_policy multibus
                path_checker readsector0
        }
}

but multipathd -k"show conf" says:

multipaths {
        multipath {
                wwid 22263000155ada9e9
                path_grouping_policy failover
        }
        multipath {
                wwid 36090a018108277e8ed92e4e9cee1733e
                path_grouping_policy multibus
        }

and multipath -v3 shows them all

sdb: path checker = readsector0 (config file default)

while the grouping policy seems to work, 

pgpolicy = multibus (LUN setting)

I'm sure I can use 'tur' on both multipaths via the defaults {} section
and be fine, but from the docs (even checked the RHEL 5.3 beta SRPM)
this should work.
-- 
Matthew Kent \ SA \ bravenet.com
