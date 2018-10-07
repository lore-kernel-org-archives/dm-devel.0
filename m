From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: refresh kernel-doc from
	kernel sources
Date: Sun, 7 Oct 2018 14:14:53 +0200
Message-ID: <b0c2c872-38a0-c097-01c1-f9335c18986d@gmail.com>
References: <20180818203852.15230-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180818203852.15230-1-xose.vazquez@gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Gris Ge <fge@redhat.com>, DM-DEV ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

This one is missing.

On 8/18/18 10:38 PM, Xose Vazquez Perez wrote:
> Cc: Gris Ge <fge@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEV ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libdmmp/docs/kernel-doc | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc
> index 0057d8e..8f0f508 100755
> --- a/libdmmp/docs/kernel-doc
> +++ b/libdmmp/docs/kernel-doc
> @@ -1062,7 +1062,7 @@ sub dump_struct($$) {
>      my $x = shift;
>      my $file = shift;
>  
> -    if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
> +    if ($x =~ /(struct|union)\s+(\w+)\s*\{(.*)\}/) {
>  	my $decl_type = $1;
>  	$declaration_name = $2;
>  	my $members = $3;
> @@ -1148,20 +1148,20 @@ sub dump_struct($$) {
>  				}
>  			}
>  		}
> -		$members =~ s/(struct|union)([^\{\};]+)\{([^\{\}]*)}([^\{\}\;]*)\;/$newmember/;
> +		$members =~ s/(struct|union)([^\{\};]+)\{([^\{\}]*)\}([^\{\}\;]*)\;/$newmember/;
>  	}
>  
>  	# Ignore other nested elements, like enums
> -	$members =~ s/({[^\{\}]*})//g;
> +	$members =~ s/(\{[^\{\}]*\})//g;
>  
>  	create_parameterlist($members, ';', $file, $declaration_name);
>  	check_sections($file, $declaration_name, $decl_type, $sectcheck, $struct_actual);
>  
>  	# Adjust declaration for better display
> -	$declaration =~ s/([{;])/$1\n/g;
> -	$declaration =~ s/}\s+;/};/g;
> +	$declaration =~ s/([\{;])/$1\n/g;
> +	$declaration =~ s/\}\s+;/};/g;
>  	# Better handle inlined enums
> -	do {} while ($declaration =~ s/(enum\s+{[^}]+),([^\n])/$1,\n$2/);
> +	do {} while ($declaration =~ s/(enum\s+\{[^\}]+),([^\n])/$1,\n$2/);
>  
>  	my @def_args = split /\n/, $declaration;
>  	my $level = 1;
> @@ -1171,12 +1171,12 @@ sub dump_struct($$) {
>  		$clause =~ s/\s+$//;
>  		$clause =~ s/\s+/ /;
>  		next if (!$clause);
> -		$level-- if ($clause =~ m/(})/ && $level > 1);
> +		$level-- if ($clause =~ m/(\})/ && $level > 1);
>  		if (!($clause =~ m/^\s*#/)) {
>  			$declaration .= "\t" x $level;
>  		}
>  		$declaration .= "\t" . $clause . "\n";
> -		$level++ if ($clause =~ m/({)/ && !($clause =~m/}/));
> +		$level++ if ($clause =~ m/(\{)/ && !($clause =~m/\}/));
>  	}
>  	output_declaration($declaration_name,
>  			   'struct',
> @@ -1244,7 +1244,7 @@ sub dump_enum($$) {
>      # strip #define macros inside enums
>      $x =~ s@#\s*((define|ifdef)\s+|endif)[^;]*;@@gos;
>  
> -    if ($x =~ /enum\s+(\w+)\s*{(.*)}/) {
> +    if ($x =~ /enum\s+(\w+)\s*\{(.*)\}/) {
>  	$declaration_name = $1;
>  	my $members = $2;
>  	my %_members;
> @@ -1785,7 +1785,7 @@ sub process_proto_type($$) {
>      }
>  
>      while (1) {
> -	if ( $x =~ /([^{};]*)([{};])(.*)/ ) {
> +	if ( $x =~ /([^\{\};]*)([\{\};])(.*)/ ) {
>              if( length $prototype ) {
>                  $prototype .= " "
>              }
> 
