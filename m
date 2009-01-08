From: Konrad Rzeszutek <konrad-/HHyZTb1IPUUqSzUVP1SBw@public.gmane.org>
Subject: Re: [dm-devel] multipathd: sdc: readsector0 checker reports path is down
Date: Thu, 8 Jan 2009 14:56:43 -0500
Message-ID: <20090108195643.GB20058@mars.virtualiron.com>
References: <20090108193137.GA3953@esri.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20090108193137.GA3953-v48TKWNzwFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: dm-devel.ids


On Thu, Jan 08, 2009 at 11:31:38AM -0800, Ray Van Dolson wrote:
> I'm still getting the hang of iSCSI and multipath, so bear with me if
> this is a FAQ that I've missed...
> 
> I have a host attaching to an MD3000i via iSCSI/dm-multipath that is
> working but showing a lot of the following errors in syslog:
> 
>   multipathd: sdc: readsector0 checker reports path is down

You are using the wrong path checker, wrong path priority program,
and no hardware path checker :-(

Here is what you need in your multipath.conf file:

 #   
    # DELL :D3000i :: Active-Passive RDAC
    # Note: The same as the IBM DS3300
    #   
    device {
        vendor          "DELL"
        product         "MD3000i"
        product_blacklist   "Universal Xport"
        features        "1 queue_if_no_path"
        path_grouping_policy    group_by_prio
        hardware_handler    "1 rdac"
        path_checker        rdac
        prio            "rdac"
        failback        immediate
    }   


Thought you might need to replace the 'prio	"rdac"' with
'prio_callout	"/sbin/mpath_prio_rdac" as I think RHEL5/CentOS5 uses
the old calling convention.

This should get rid of your down errors and show your passive/active path
properly.
