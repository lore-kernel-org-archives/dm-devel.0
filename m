From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [patch] mpath_prio_pp
Date: Thu, 10 Jan 2008 17:48:24 -0500 (EST)
Message-ID: <20080110.174824.08317843.k-ueda@ct.jp.nec.com>
References: <4640E676B7B93749BC82C75D50E500FB0570FBF4@BGEEXC07.asiapacific.cpqcorp.net>
	<4640E676B7B93749BC82C75D50E500FB05B2EF5C@BGEEXC07.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4640E676B7B93749BC82C75D50E500FB05B2EF5C@BGEEXC07.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: veena-s.t@hp.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Veena,

On Wed, 9 Jan 2008 15:15:38 +0530, "T S, Veena (STSD)" wrote:
> Purpose of the patch-
> -- To introduce the prio_callout attribute into the multipath section of
> the configuration file.

The prio_callout feature has been changed to the libprio.
Please check the latest Christophe's git.


> -- To implement the preferred path feature in device mapper.
> 
> Uses of the patch-
> -- Prio_callout attribute in the multipath section allows users to write
> callout routines,which can be specific to a LUN.
> -- When it is known the performance of one of the path is better than
> the other available paths for a particular LUN, the user can set it as
> preferred path.

How about opposite case such as the performance of some paths are
better than the one backup path for a particular LUN?
So if we can specify some preferred paths, that may be more useful.


> +int main(int argc, char * argv[]) 
> +{ 
> + 
> +       char path[FILE_NAME_SIZE]; 
> +       
> +       if(argv[1] && argv[2]) 
> +       { 
> +               if(!strncmp(argv[2],"/dev/",5)) 
> +                       strcpy(path,argv[2]+5); 
> + 
> +               if(!strcmp(path,argv[1]) || !strcmp(argv[1],argv[2])) 
> +               { 
> +                       printf("%u\n", HIGH); 
> +                       return 0; 
> +               } 
> +               else 
> +               { 
> +                       printf("%u\n", LOW); 
> +                       return 0; 
> +               } 
> +       } 
> +       return -1; 
> +} 

This prioritizer looks that we need to specify the preferred path
by devnode or major/minor, right?
If so, it doesn't work reliably.
Both devnode and major/minor may vary for each system reboot.
It's horrible to check and change the config file after every reboot.
We should be able to use more persistent name to specify a path,
though I don't have a good idea now...

Thanks,
Kiyoshi Ueda
